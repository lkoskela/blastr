module Blastr

  class UsageError < ArgumentError
    
    USAGE_TEXT = <<EOS

    Usage: blastr URL [revision]
    
    The options are as follows:
    
      URL        (required)  The URL identifying the source repository
                 you want to observe. For Subversion repositories the
                 URL could be, for example, "http://svn.foo.com/bar" or
                 "svn://svn.foo.com/bar". For a Git repository, the URL
                 usually looks like "git://github.com/foo/bar.git".
                 
      revision   (optional)  The revision or commit you want to start
                 observing from. For a Subversion repository, this 
                 would be a number (e.g. 123 or 5000). For Git, the
                 revision would be the commit SHA hash - something that
                 looks like "4d1863552c03bc1ff9c9376b9a24b04daabc67e2".
                 When this option is omitted, Blastr starts observing
                 from the latest revision onwards.

EOS
    
    def initialize
      super(USAGE_TEXT)
    end
  end

end