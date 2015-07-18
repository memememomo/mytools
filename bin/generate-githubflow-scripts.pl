#!/usr/bin/perl#------------------------------
# githubflowのショートカットシェルスクリプトを生成する
#------------------------------
use strict;
use warnings;
 
 
my $dir = $ENV{'HOME'} . '/bin';
 
if (!$dir) {
    die "出力先ディレクトリを指定してください。\nUsage: $0 {directory}\n";
}
 
if (! -d $dir) {
    die "ディレクトリではありません。: $dir\n";
}
 
if (! -w $dir) {
    die "このディレクトリに書き込めません。: $dir\n";
}
 
 
my $filename = '';
my $buf = '';
while (my $line = <DATA>) {
    if ($line =~ /^\-\-\-(.+)/) {
        my $f = $1;
        if ($filename && $buf) {
            generate_file($filename, $buf);
        }
        $filename = $f;
        $buf = '';
    }
    else {
        $buf .= $line;
    }
}
 
if ($filename && $buf) {
    generate_file($filename, $buf);
}
 
 
sub generate_file {
    my ($filename, $buf) = @_;
 
    my $path = "$dir/$filename";
 
    open my $fh, '>', $path or die "Can't open: $path";
    print $fh $buf;
    close $fh;
 
    chmod 0755, $path;
 
    print "creating $path\n";
}
 
 
__DATA__
---gcurpull
#!/bin/sh
 
branch=$1
 
if [ -z $branch ]; then
    branch=`git rev-parse --abbrev-ref HEAD`
fi
 
echo "pull $branch OK?(y/N)"
 
read ans
 
if [ "$ans" != "y" ]; then
    exit;
fi
 
git pull origin $branch
---gcurpush
#!/bin/sh
 
branch=$1
 
if [ -z $branch ]; then
    branch=`git rev-parse --abbrev-ref HEAD`
fi
 
echo "push $branch OK?(y/N)"
 
read ans
 
if [ "$ans" != "y" ]; then
    exit;
fi
 
git push origin $branch
---gf
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {feature-name}"
    exit;
fi
 
git checkout feature/$1
---gh
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {hotfix-name}"
    exit;
fi
 
git checkout hotfix/$1
---genbrf
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {feature-name}"
    exit;
fi
 
 
git branch feature/$1 master && git checkout feature/$1
---genbrh
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {hotfix-name}"
    exit;
fi
 
 
git branch hotfix/$1 master && git checkout hotfix/$1
---mergebr
#!/bin/sh
 
if [ -z $1 ]; then
    echo "Usage: $0 {branch-name}"
    exit;
fi
 
git checkout master && git merge $1 && echo "merged $1"
#------------------------------
# githubflowのショートカットシェルスクリプトを生成する
#------------------------------
use strict;
use warnings;
 
 
my $dir = $ARGV[0];
 
if (!$dir) {
    die "出力先ディレクトリを指定してください。\nUsage: $0 {directory}\n";
}
 
if (! -d $dir) {
    die "ディレクトリではありません。: $dir\n";
}
 
if (! -w $dir) {
    die "このディレクトリに書き込めません。: $dir\n";
}
 
 
my $filename = '';
my $buf = '';
while (my $line = <DATA>) {
    if ($line =~ /^\-\-\-(.+)/) {
        my $f = $1;
        if ($filename && $buf) {
            generate_file($filename, $buf);
        }
        $filename = $f;
        $buf = '';
    }
    else {
        $buf .= $line;
    }
}
 
if ($filename && $buf) {
    generate_file($filename, $buf);
}
 
 
sub generate_file {
    my ($filename, $buf) = @_;
 
    my $path = "$dir/$filename";
 
    open my $fh, '>', $path or die "Can't open: $path";
    print $fh $buf;
    close $fh;
 
    chmod 0755, $path;
 
    print "creating $path\n";
}
 
 
__DATA__
---gcurpull
#!/bin/sh
 
branch=$1
 
if [ -z $branch ]; then
    branch=`git rev-parse --abbrev-ref HEAD`
fi
 
echo "pull $branch OK?(y/N)"
 
read ans
 
if [ "$ans" != "y" ]; then
    exit;
fi
 
git pull origin $branch
---gcurpush
#!/bin/sh
 
branch=$1
 
if [ -z $branch ]; then
    branch=`git rev-parse --abbrev-ref HEAD`
fi
 
echo "push $branch OK?(y/N)"
 
read ans
 
if [ "$ans" != "y" ]; then
    exit;
fi
 
git push origin $branch
---gf
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {feature-name}"
    exit;
fi
 
git checkout feature/$1
---gh
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {hotfix-name}"
    exit;
fi
 
git checkout hotfix/$1
---genbrf
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {feature-name}"
    exit;
fi
 
 
git branch feature/$1 master && git checkout feature/$1
---genbrh
#!/bin/sh
 
if [ -z $1 ];  then
    echo "Usage: $0 {hotfix-name}"
    exit;
fi
 
 
git branch hotfix/$1 master && git checkout hotfix/$1
---mergebr
#!/bin/sh
 
if [ -z $1 ]; then
    echo "Usage: $0 {branch-name}"
    exit;
fi
 
git checkout master && git merge $1 && echo "merged $1"
