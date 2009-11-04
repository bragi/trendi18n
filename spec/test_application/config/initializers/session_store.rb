# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_praktyki_session',
  :secret      => '3a5952fd8e413d86a4d5631df2aba673bed55b5ce28a943aa7d74067107f860c66cc181c01a94c5068150a7df56feb9c61c7dc014c1104aa80b4f8bc9744bf00'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
