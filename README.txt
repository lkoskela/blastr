= Blastr, the audible commit radiator

* http://rubyforge.org/projects/blastr/

== DESCRIPTION:

Blastr observes a version control repository for commits and makes audible 
announcements out of the commit messages. It currently supports Subversion, 
Git, and Mercurial on Linux and OS X, possibly on other UNIX-like operating 
systems as well.

See the project website at Rubyforge[http://rubyforge.org/projects/blastr/]
to file a bug report or submit a feature request.

=== FEATURES:

Blastr can observe a "branch" (identified by a URL) by polling the
repository for a commit log. Any new commits will be announced. When 
starting Blastr, it can be told to start observing from a given revision
or let it figure out the latest revision and start from that.

The supported version control systems include:

* Subversion[http://subversion.tigris.org]
* Git[http://git-scm.com]
* Mercurial[http://www.selenic.com/mercurial]

The supported operating systems (for running Blastr) include:

* Mac OS X
* Linux (requires the eSpeak[http://espeak.sourceforge.net/] or Festival[http://www.cstr.ed.ac.uk/projects/festival/] text-to-speech utility)

=== SYNOPSIS:

Subversion:

  blastr http://svn.acme.com/foo/trunk

  blastr http://svn.acme.com/foo/trunk 123

  blastr file:///var/svnrepo

  blastr /var/svnrepo

Git:

  blastr git://github.com/lkoskela/blastr.git

  blastr git://github.com/lkoskela/blastr.git e528509fddd57194f1c497ce6583f6869e8ed62c

  blastr file:///var/gitrepo

  blastr /var/gitrepo

Mercurial:

  blastr hg:http://hg.serpentine.com/tutorial/hello

  blastr hg:http://hg.serpentine.com/tutorial/hello 2

=== REQUIREMENTS:

Blastr depends on the git[http://git.rubyforge.org/] gem (>= 1.0.5).
This dependency should be installed automatically when you install
Blastr.

Blastr also depends on the standard command line client for the source 
repository in question being in the user's PATH. For example, in order 
to observe a Subversion repository the "svn" executable needs to be in 
PATH. For Git, the "git" executable needs to be in PATH. For Mercurial, 
"hg" needs to be in PATH.

Furthermore, Blastr needs a text-to-speech utility for making those 
commit messages audible. On Mac OS X Blastr uses the built-in "say" 
utility so Mac users don't need to worry about this. On Linux, Blastr
can utilize Festival[http://www.cstr.ed.ac.uk/projects/festival/] and 
eSpeak[http://espeak.sourceforge.net/].

=== INSTALL:

First, install Blastr and its gem dependencies:

  sudo gem install blastr

Then, download and install your chosen version control system's toolset
and make sure it's on your PATH when running Blastr.

Then, if applicable, download and install a text-to-speech utility for
your platform.

=== KNOWN PROBLEMS AND GOTCHAS:

* Blastr currently does a full clone operation on every poll for 
  source repositories that don't support a purely remote operation (like
  "svn log [URL]"). This may take a while if your repository is big.
* Blastr doesn't treat non-ASCII characters in commit messages too well. 
  In other words, the developers make no promises whatsoever regarding 
  Blastr's behavior when encountering weird Norwegian scribble.
* Some folks might want to monitor multiple repositories or multiple 
  paths or branches within a repository at the same time. Currently,
  this is technically possible by running two instances of Blastr in
  parallel but every now and then those two instances will speak over
  each other (i.e. all you can hear is cacophony).

=== LICENSE:

(The BSD License)

Copyright (c) 2009, Lasse Koskela
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.
* Neither the name of this software nor the names of its contributors may 
  be used to endorse or promote products derived from this software without 
  specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.

