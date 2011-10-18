#!perl -w
use strict;
use warnings;
use Benchmark qw(:all);
use Hash::FieldHash;
{
    package ByHand;
    my %foo_of;
    my %bar_of;
    sub new {
        my($class, $a, $b) = @_;
        my $self = bless {}, $class;
        $foo_of{$self} = $a;
        $bar_of{$self} = $b;
        return $self;
    }
    sub DESTROY {
        my($self) = @_;
        delete $foo_of{$self};
        delete $bar_of{$self};
    }
}
{
    package ByFH;
    Hash::FieldHash::fieldhashes \my(%foo_of, %bar_of);
    sub new {
        my($class, $a, $b) = @_;
        my $self = bless {}, $class;
        $foo_of{$self} = $a;
        $bar_of{$self} = $b;
        return $self;
    }
}

cmpthese timethese -1, {
    ByHand => sub {
        for(1 .. 100) {
            my $o = ByHand->new(10, 20);
        }
    },
    ByFieldHash => sub {
        for(1 .. 100) {
            my $o = ByFH->new(10, 20);
        }
    },
};


