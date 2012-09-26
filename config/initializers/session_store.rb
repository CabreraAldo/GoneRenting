# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_GoneRenting_session',
  :secret      => '9cae4d5d8b1bb83b2775715269b45ece12f9a9cbb9ceec394832f727a305d8dcdac49abe11848824ccdfd1817849ca89b8bdba978f944e6ff1fc38043638dd73'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
