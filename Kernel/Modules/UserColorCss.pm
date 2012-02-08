package Kernel::Modules::UserColorCss;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
  my ( $Type, %Param ) = @_;

  # allocate new hash for object
  my $Self = {%Param};
  bless( $Self, $Type );
  for my $Needed (qw(DBObject LayoutObject ConfigObject UserObject)) {
    if ( !$Self->{$Needed} ) {
      $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
    }
  }
  $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

  return $Self;
}

sub Run {
  my ( $Self, %Param ) = @_;

  # get test page header
  my $Output = <<"EOT";
Content-Type: text/css; charset=utf-8;
Expires: Tue, 1 Jan 1980 12:00:00 GMT
Cache-Control: no-cache
Pragma: no-cache

EOT

  my %users = $Self->{UserObject}->UserList(Valid => 1);
  for (keys %users) {
    my $login = $users{$_};
    my %prefs = $Self->{UserObject}->GetPreferences(UserID => $_);
    my $email = $prefs{"UserEmail"};
    my $color = $prefs{"UserColor"};
    next unless ($color =~ /#(..)(..)(..)/);
    $intensity = (hex($1)+hex($2)+hex($3))/(3*255.0);
    $foregroundcolor = ($intensity > 0.5) ? '#fff' : '#000';
    $Output .= <<"EOT";
[title~="($login)"], [title="$email"] {
background-color: $color !important;
foreground-color: $foregroundcolor !important;
}
EOT
  }
  return $Output;
}

1;
