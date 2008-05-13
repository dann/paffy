package Paffy::Date;
use strict;
use base qw( DateTime );

use Encode;
use DateTime::Format::Strptime;
use DateTime::TimeZone;
use UNIVERSAL::require;

sub rebless { bless $_[1], $_[0] }

sub parse {
    my($class, $format, $date) = @_;

    my $module;
    if (ref $format) {
        $module = $format;
    } else {
        $module = "DateTime::Format::$format";
        $module->require or die $@;
    }

    my $dt = $module->parse_datetime($date) or return;
    bless $dt, $class;
}

sub strptime {
    my($class, $pattern, $date) = @_;
    Encode::_utf8_on($pattern);
    my $format = DateTime::Format::Strptime->new(pattern => $pattern);
    $class->parse($format, $date);
}

sub now {
    my($class, %opt) = @_;
    my $self = $class->SUPER::now();

    my $tz = $opt{timezone} ||'local';
    $self->set_time_zone($tz);

    $self;
}

sub from_epoch {
    my $class = shift;
    my %p = @_ == 1 ? (epoch => $_[0]) : @_;
    $class->SUPER::from_epoch(%p);
}

sub format {
    my($self, $format) = @_;

    my $module;
    if (ref $format) {
        $module = $format;
    } else {
        $module = "DateTime::Format::$format";
        $module->require or die $@;
    }

    $module->format_datetime($self);
}

sub set_time_zone {
    my $self = shift;

    eval {
        $self->SUPER::set_time_zone(@_);
    };
    if ($@) {
        $self->SUPER::set_time_zone('UTC');
    }

    return $self;
}

sub serialize {
    my $self = shift;
    $self->format('W3CDTF');
}

1;

__END__
