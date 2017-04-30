#! /bin/sed -f

/^$/! {
	s/^/String /
	s/$/\nKeyStrPress Return\nKeyStrRelease Return/
	bend
}

s/.*/\nKeyStrPress Return\nKeyStrRelease Return/

$a\
KeyStrPress Control_L\
KeyStrPress s\
KeyStrRelease s\
KeyStrRelease Control_L\
KeyStrPress Alt_L\
KeyStrPress F4\
KeyStrRelease Alt_L\
KeyStrRelease F4

:end

