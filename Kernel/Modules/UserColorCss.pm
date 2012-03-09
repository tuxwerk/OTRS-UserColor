package Kernel::Modules::UserColorCss;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CheckItem;
use Kernel::System::Cache;

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
  $Self->{CacheObject} = Kernel::System::Cache->new( %Param );

  return $Self;
}

sub Run {
  my ( $Self, %Param ) = @_;

my $Output = <<"EOT";
Content-Type: text/css; charset=utf-8;

EOT

  my %users = $Self->{UserObject}->UserList(Valid => 1);
  for (keys %users) {
    my $login = $users{$_};
    my %prefs = $Self->{UserObject}->GetUserData(UserID => $_);
    my $email = $prefs{"UserEmail"};
    my $color = $prefs{"UserColor"};
    # match the three hex values of #1ab423
    # black is saved as #000, this must also be accounted for
    next unless ($color =~ /^#(..?)(..?)(..?)$/);
    my $intensity = (hex($1)+hex($2)+hex($3))/(3*255.0);
    my $foregroundcolor = ($intensity < 0.5) ? '#fff' : '#000';
    $Output .= <<"EOT";
[title~="($login)"], [title="$email"] {
background-color: $color !important;
color: $foregroundcolor !important;
}
EOT
  }
}
  return $Output;
}
1;
