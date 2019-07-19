package App::ListCurrencies;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

our %SPEC;
use Exporter qw(import);
our @EXPORT_OK = qw(list_languages);

our $data;
{
    require Locale::Codes::Currency_Codes;
    $data = [];
    my $id2names  = $Locale::Codes::Data{'currency'}{'id2names'};
    my $id2alpha  = $Locale::Codes::Data{'currency'}{'id2code'}{'alpha'};

    for my $id (keys %$id2names) {
        push @$data, [$id2alpha->{$id}, $id2names->{$id}[0]];
    }

    $data = [sort {$a->[0] cmp $b->[0]} @$data];
}

my $res = gen_read_table_func(
    name => 'list_currencies',
    summary => 'List currencies',
    table_data => $data,
    table_spec => {
        summary => 'List of currencies',
        fields => {
            numeric => {
                summary => 'ISO 4217 numeric code',
                schema => 'int*',
                pos => 0,
                sortable => 1,
            },
            alpha => {
                summary => 'ISO 4217 alpha code',
                schema => 'str*',
                pos => 1,
                sortable => 1,
            },
            en_name => {
                summary => 'English name',
                schema => 'str*',
                pos => 2,
                sortable => 1,
            },
        },
        pk => 'alpha',
    },
    description => <<'_',

Source data is generated from `Locale::Codes::Currency_Codes`. so make sure you
have a relatively recent version of the module.

_
);
die "Can't generate function: $res->[0] - $res->[1]" unless $res->[0] == 200;

1;
#ABSTRACT:

=head1 SYNOPSIS

 # Use via list-currencies CLI script


=head1 SEE ALSO

L<Locale::Codes>

L<list-countries> from L<App::ListCountries>

L<list-languages> from L<App::ListLanguages>

=cut
