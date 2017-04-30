###
## Manifest
#
class Manifest

	def initialize
		@versionCode = "1"
		@versionName = "1.0"
		@package     = "__PKG__"
		@permissions = "
						INTERNET
						ACCESS_NETWORK_STATE
						CAMERA
						RECORD_AUDIO
						WRITE_EXTERNAL_STORAGE
						WAKE_LOCK
		                ".split
	end

	###
	## Header.
	#
	def manifest
		{ "android:versionCode" => @versionCode,
		  "android:versionName" => @versionName,
		  :package              => @package,
		  "xmlns:android"       => "http://schemas.android.com/apk/res/android" }
	end

	###
	## Redimensionamento de tela.
	#
	def screen
		{ "android:anyDensity"    => "true",
		  "android:largeScreens"  => "true",
		  "android:normalScreens" => "true",
		  "android:smallScreens"  => "true" }
	end

	def get_permissions
		@permissions
	end

	def get_package
		@package
	end

end
