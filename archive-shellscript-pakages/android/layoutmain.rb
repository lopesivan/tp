###
## LayoutMain
#
class LayoutMain
	attr_reader :id_name,
	            :count_iv,
	            :count_tv

	def initialize(a_id_name = "main_layout" )
	    @count_iv = 0
	    @count_tv = 0
		@id_name  = a_id_name
	end

##############################################################################
################################## HEADER ####################################
##############################################################################

	###
	## Header.
	#
	def header()
		{ "android:id"            => "@+id/#{@id_name}",
		  "android:layout_height" => "fill_parent",
		  "android:layout_width"  => "fill_parent",
		  "xmlns:android"         => "http://schemas.android.com/apk/res/android" }
	end

	def layout_wh(option)
		case option
		when "ff"
			{ "android:layout_width"  => "fill_parent",
			  "android:layout_height" => "fill_parent" }
		when "wf"
			{ "android:layout_width"  => "wrap_content",
			  "android:layout_height" => "fill_parent" }
		when "fw"
			{ "android:layout_width"  => "fill_parent",
			  "android:layout_height" => "wrap_content" }
		when "ww"
			{ "android:layout_width"  => "wrap_content",
			  "android:layout_height" => "wrap_content" }
		else
			{ "android:layout_width"  => "fill_parent",
			  "android:layout_height" => "fill_parent" }
		end
	end

    # ========================================================================
    # ** TextView **
    # ========================================================================
	def tv()
		@count_tv = @count_tv + 1
		{ "android:id" => "@+id/#{@id_name}TextView_#{count_tv}" }
	end
    # ========================================================================
    # ** ImageView **
    # ========================================================================
	def iv()
		@count_iv = @count_iv + 1
		{ "android:id" => "@+id/#{@id_name}ImageView_#{count_iv}" }
	end

    # ========================================================================
    # ** Others ... **
    # ========================================================================
	def vertical()
		{ "android:orientation" => "vertical" }
	end

	def img(image_name)
		{ "android:src" => "@drawable/#{image_name}" }
	end

	def text(text)
		{ "android:text" => "#{text}" }
	end

	def bg(color)
		{ "android:background" => "#{color}" }
	end
end
