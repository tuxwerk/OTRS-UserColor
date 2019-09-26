# --
# Kernel/Modules/UserColorCss.pm - creates the css
# Copyright (C) 2012-2016 tuxwerk - http://www.tuxwerk.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::UserColorCss;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
  my ( $Type, %Param ) = @_;

  # allocate new hash for object
  my $Self = {%Param};
  bless( $Self, $Type );

  return $Self;
}

sub Run {
  my ( $Self, %Param ) = @_;
  my $UserObject = $Kernel::OM->Get('Kernel::System::User');

  my $Output = <<"EOT";
Content-Type: text/css; charset=utf-8;

EOT

  my %users = $UserObject->UserList(Valid => 1);
  for (keys %users) {
    my $login = $users{$_};
    my %prefs = $UserObject->GetUserData(UserID => $_);
    my $email = $prefs{"UserEmail"};
    my $color = $prefs{"UserColor"};
    # match the three hex values of #1ab423
    # black is saved as #000, this must also be accounted for
    next unless ($color && $color =~ /^#(..?)(..?)(..?)$/);
    my $intensity = (hex($1)+hex($2)+hex($3))/(3*255.0);
    my $foregroundcolor = ($intensity < 0.5) ? '#fff' : '#000';
    $Output .= <<"EOT";
[title~="($login)"], [title="$email"] {
background-color: $color !important;
color: $foregroundcolor !important;
display: block !important;
}
.DashboardUserOnline [title="$email"] > span {
background-color: $color !important;
color: $foregroundcolor !important;
width: 100% !important;
}
EOT
  }
  return $Output;
}
1;
