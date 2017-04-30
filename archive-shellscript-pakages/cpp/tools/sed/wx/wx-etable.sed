#! /bin/sed -f

i\
\/\/ Event table for __MYFRAME__\
BEGIN_EVENT_TABLE(__MYFRAME__, wxFrame)\

/\<about\>/{
i\
	EVT_MENU(wxID_ABOUT,  __MYFRAME__::OnAbout)
}

/\<any\>/{
i\
	EVT_MENU(wxID_ANY,    __MYFRAME__::OnMethod)
}

/\<copy\>/{
i\
	EVT_MENU(wxID_COPY,   __MYFRAME__::OnMethod)
}

/\<exit\>/{
i\
	EVT_MENU(wxID_EXIT,   __MYFRAME__::OnMethod)
}

/\<help\>/{
i\
	EVT_MENU(wxID_HELP,   __MYFRAME__::OnMethod)
}

/\<open\>/{
i\
	EVT_MENU(wxID_OPEN,   __MYFRAME__::OnMethod)
}

/\<paste\>/{
i\
	EVT_MENU(wxID_PASTE,  __MYFRAME__::OnMethod)
}

/\<print\>/{
i\
	EVT_MENU(wxID_PRINT,  __MYFRAME__::OnMethod)
}

/\<save\>/{
i\
	EVT_MENU(wxID_SAVE,   __MYFRAME__::OnMethod)
}

/\<saveas\>/{
i\
	EVT_MENU(wxID_SAVEAS, __MYFRAME__::OnMethod)
}

/\<stop\>/{
i\
	EVT_MENU(wxID_STOP,   __MYFRAME__::OnMethod)
}

i\
\
END_EVENT_TABLE()

##############################################################################

#
# about
#
/\<about\>/! b__case__01__goto
i\
\
void __MYFRAME__::OnAbout(wxCommandEvent& event)\
{\
	wxString msg;\
	msg.Printf(wxT("Hello and welcome to %s"),\
		   wxVERSION_STRING);\
\
	wxMessageBox(msg, wxT("About ICSL"),\
		     wxOK | wxICON_INFORMATION, this);\
}
:__case__01__goto

#
# any
#
/\<any\>/!   b__case__02__goto
i\
***tem any***

:__case__02__goto

#
# copy
#
/\<copy\>/!  b__case__03__goto
i\
***tem copy***

:__case__03__goto

#
# exit
#
/\<exit\>/!  b__case__04__goto
i\
***tem exit***

:__case__04__goto

#
# help
#
/\<help\>/! b__case__05__goto
i\
***tem help***

:__case__05__goto

#
# open
#
/\<open\>/! b__case__06__goto
i\
***tem open***

:__case__06__goto

#
# paste
#
/\<paste\>/! b__case__07__goto
i\
***tem paste***

:__case__07__goto

#
# print
#
/\<print\>/! b__case__08__goto
i\
***tem print***

:__case__08__goto

#
# save
#
/\<save\>/! b__case__09__goto
i\
***tem save***

:__case__09__goto

#
# saveas
#
/\<saveas\>/! b__case__10__goto
i\
***tem saveas***

:__case__10__goto

#
# stop
#
/\<stop\>/! b__case__11__goto
i\
***tem stop***

:__case__11__goto

##############################################################################
i\
\
void __MYFRAME__::OnQuit(wxCommandEvent& event)\
{\
	\/\/ Destroy the frame\
	Close();\
}

# Clean output!
x
