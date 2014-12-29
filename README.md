# Doctrinator

A tool to check fittings and doctrines against your corp member’s abilities.

## Details

Players represent the human operating the computer. A Player can have multiple
accounts, and so multiple API keys. Each API key can be for at most three
Pilots. Each Pilot has their own unique set of skills.

Fittings are ship fits. They are imported via EFT formatting as that is now the
default import/export from the EVE client itself. When viewing a specific fit,
you will see a list of added Pilots and wether-or-not they can fly that fit. If
they cannot, clicking the resulting button will review the skills that are
missing.

When viewing a fitting, if a pilot has not yet had skills imported, or if they
haven’t been updated for 12 hours or more, the system will trigger a background
request to update the skills.
