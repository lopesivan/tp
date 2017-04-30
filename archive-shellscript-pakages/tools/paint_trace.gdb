# Copyright (c) 2008, Stéphan Kochen <stephan@kochen.nl>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the copyright holder nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# Not output limit, this is all automated
set height 0
# Log to a file gdb.txt
set logging on
set logging redirect on

# Wait until shared library symbols are loaded. If your application needs parameters, they should
# be specified here. This won't work for applications that link at runtime, like Python.
start

# This is where we store the values of out-parameters, like those of gdk_drawable_get_size.
# It's a small memory leak, I guess.
set $_xywh = (int*)malloc(sizeof(int)*4)


# Print the widget type name
define print_widget_info
  printf "%s %s\n", $arg1, g_type_name(((GTypeInstance*)$arg0)->g_class->g_type)
end

# Print the drawable type name, address, position, size and parent
define print_drawable_info
  set $_dtype = g_type_name(((GTypeInstance*)$arg0)->g_class->g_type)
  set $_junk = gdk_drawable_get_size($arg0, $_xywh+2, $_xywh+3)
  if g_type_check_instance_is_a($arg0, gdk_window_object_get_type())
    set $_junk = gdk_window_get_position($arg0, $_xywh, $_xywh+1)
    #set $_parent = ((GdkWindowObject*)$arg0)->parent
    printf "%s %s (%p): x=%d, y=%d, w=%d, h=%d, parent=%p\n", $arg1, $_dtype, $arg0, *($_xywh+0), *($_xywh+1), *($_xywh+2), *($_xywh+3), ((GdkWindowObject*)$arg0)->parent
    if ((GdkWindowObject*)$arg0)->parent != 0
      print_drawable_info ((GdkWindowObject*)$arg0)->parent "Parent"
    end
  else
    printf "%s %s (%p): w=%d, h=%d\n", $arg1, $_dtype, $arg0, *($_xywh+2), *($_xywh+3)
  end
end

# Print a GdkRectangle's position and size.
define print_rect
  printf "%s rect: x=%d, y=%d, w=%d, h=%d\n", $arg1, $arg0->x, $arg0->y, $arg0->width, $arg0->height
end

# Print all the info needed from a gtk_paint_* call
define print_paint_trace
  print_widget_info widget "Widget"
  print_drawable_info window "Destination"
  if area == 0
    printf "No clipping bounds.\n"
  else
    print_rect area "Clip"
  end
end


# GtkProgress is a pain, and we need to catch the gdk_drawable_draw_drawable call.
break gtk_progress_expose
command
  print_drawable_info event->window "Destination"
  print_drawable_info ((GtkProgress*)widget)->offscreen_pixmap "Source"
  print_rect event->area "Location"
  cont
end

# And here are all the gtk_paint_* breakpoints:

break gtk_paint_arrow
command
  print_paint_trace
  cont
end

break gtk_paint_flat_box
command
  print_paint_trace
  cont
end

break gtk_paint_check
command
  print_paint_trace
  cont
end

break gtk_paint_layout
command
  print_paint_trace
  cont
end

break gtk_paint_box_gap
command
  print_paint_trace
  cont
end

break gtk_paint_extension
command
  print_paint_trace
  cont
end

break gtk_paint_box
command
  print_paint_trace
  cont
end

break gtk_paint_shadow
command
  print_paint_trace
  cont
end

break gtk_paint_shadow_gap
command
  print_paint_trace
  cont
end

break gtk_paint_resize_grip
command
  print_paint_trace
  cont
end

break gtk_paint_vline
command
  print_paint_trace
  cont
end

break gtk_paint_handle
command
  print_paint_trace
  cont
end

break gtk_paint_slider
command
  print_paint_trace
  cont
end

break gtk_paint_tab
command
  print_paint_trace
  cont
end

break gtk_paint_hline
command
  print_paint_trace
  cont
end

break gtk_paint_option
command
  print_paint_trace
  cont
end

break gtk_paint_focus
command
  print_paint_trace
  cont
end

# Start the application
cont

# Exit when done
quit

