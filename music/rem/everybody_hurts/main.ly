 \version "2.20.0"

dArpeggio = {
  d a d' fis' d' a
}

gArpeggio = {
  g, g b g' b g
}

symbols = {
  \time 6/8
  \dArpeggio
  \gArpeggio
}

\score {
  <<
    \new Staff { \clef "G_8" \symbols }
    \new TabStaff { \symbols }
    \addlyrics {
      When your day is long
      And the night
      The night is yours alone
      When you're sure you've had enough
      Of this life
      Well hang on
      Don't let yourself go
      'Cause everybody cries
      And everybody hurts sometimes
      Sometimes everything is wrong
      Now it's time to sing along
      When your day is night alone (hold on)
      (Hold on) if you feel like letting go (hold on)
      If you think you've had too much
      Of this life
      Well, hang on
      'Cause everybody hurts
      Take comfort in your friends
      Everybody hurts
      Don't throw your hand
      Oh, no
      Don't throw your hand
      If you feel like you're alone
      No, no, no, you're not alone
      If you're on your own
      In this life
      The days and nights are long
      When you think you've had too much
      Of this life
      To hang on
      Well, everybody hurts sometimes
      Everybody cries
      And everybody hurts sometimes
      And everybody hurts sometimes
      So, hold on, hold on
      Hold on, hold on
      Hold on, hold on
      Hold on, hold on
      Everybody hurts
      You are not alone
  }
  >>
}