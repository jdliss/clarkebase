require 'rails_helper'
require 'keycleaner_service'


describe "can get unsigned payment transactions" do
  it "can get unsigned" do
    VCR.use_cassette('transactions/unsigned') do

      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      wallet_b      = create(:wallet)


      from_addy = wallet_a.address
      to_addy   = wallet_b.address


      amount    = 2
      fee       = 0

      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)

      expect(post).to eq(
         {"message"=>"unsigned_transaction", "payload"=>{"hash"=>"4f7bffe8a2c269b05072aabba0f56eb50ee275e1713aaff78b1c2697848d40d2", "min-height"=>489, "timestamp"=>1465503731335, "inputs"=>[{"source-hash"=>"43367a42a9f9e0d68906ee00431666fcbc02d32b3e5f30ff5075111c03f34336", "source-index"=>0}], "outputs"=>[{"amount"=>2, "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwgj1EQmUziye3TgvaPmwKip9izipDk/1tz/UPnhhW/A7tMblqJ3V3R+Xa7f9eYGRpVQ5tlMQpv6iS45aamzSDm71D58nhgUQtHyXJ/3oWeWQtKgtJn9o0PBtMR1cNHH6xDW1ZgLi7M6a3u9O8kiY3xjXndgfJ99k9SoduNtHu9eXouG4Koz+5MwvMT3Xi+0o5bTST8QF57ab1wE+Q83SPoVSxQadASY7SVkzPP/QOieGv9diK8JVZlZ/ONYG5mLy+4R9B6MGMem8u+yTJf6ZGlLmacSpxHSdFgLfda/YC5pF1QIzon27ojrd4JajN1LyGuiCHq90n5hvAR7XTjryhwIDAQAB", "coords"=>{"transaction-id"=>"4f7bffe8a2c269b05072aabba0f56eb50ee275e1713aaff78b1c2697848d40d2", "index"=>0}}, {"amount"=>23, "address"=>"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB", "coords"=>{"transaction-id"=>"4f7bffe8a2c269b05072aabba0f56eb50ee275e1713aaff78b1c2697848d40d2", "index"=>1}}]}})
    end
  end

  it "unsigned can be signed" do
    VCR.use_cassette ('transactions/signed') do
      key           = ENV["PRIVATE_KEY"].dup
      pub           = ENV["PUBLIC_KEY"].dup
      wallet_a      = create(:wallet, private_key: key, public_key: pub)
      wallet_b      = create(:wallet)
      user_a        = wallet_a.user

      from_addy = wallet_a.address
      to_addy   = wallet_b.address
      amount    = 2
      fee       = 0



      post = ClarkeService.new.parsed_unsigned_payment(from_addy, to_addy, amount, fee)

      sig = ClarkeService.new(wallet_a.private_key).parsed_signed_payment(post)


        expect(sig.body).to eq(
          "{\"message\":\"transaction-accepted\",\"payload\":{\"hash\":\"b57376296dc13ef72c509ea8a912bd08fe44317f9374979ad2ddb751a8d48f97\",\"min-height\":489,\"timestamp\":1465503732232,\"inputs\":[{\"source-hash\":\"43367a42a9f9e0d68906ee00431666fcbc02d32b3e5f30ff5075111c03f34336\",\"source-index\":0,\"signature\":\"dslf9UNIidiP9SuEozt0MTbmxXX5gG9rYDr2PeoRny9iHS8dyrcZwJkopgqNOg/oNECF2YXMW8GC5qTnNEfSI2gI2eKMe8KQhOdw3FUgl8wOIza5sWh3qu2YGQyfnbsiLXa/xKEUPrKOmmeMKBruv+EzHrAVd9wUMJxvjdUrCRxRpx0b9lCi+40XXX27FFh7kMqMjYGtVJu38yHj4S036nmJBB0EF0M5Law/RiETISdLQuXiz+M+venY4iq517QW3lSQLTmHscaG/eZ/0lQ/J27DC6P5IWdrJm9NokmqJYmUHSCWs5RJ8n19XCPOS9IJS8Hia8q+VsE6hBqMIRhjAQ==\"}],\"outputs\":[{\"amount\":2,\"address\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA15z+606gfadubyxHCYtIUNShfLb5PKHsQZb8xLL31X8RtXvgg2flYp9SubYJqmJVpvLrtJZcjVImOpJgGlNyBk5KUaEBhROjjdInI6cRg4K7UuAF1GXfagUo5EBZyK9TVRS4zIwEwzZCJZRdWxnufuPxvQmUCgUwiQ/Z+PjgrfgFePIurtF7SBuAQvBZwWaSfUpU8mLud97c+uCTXJd4MfwuqAMjI/bxbrg5yUveAy1bI8zfQBUm/TFbkp2lzGxf+vsCoB30bB4WiSawoNsP+o4bUZkJ3K+FRQOdqNxwokofvfAwpN5dOZgBZGXYVQPeS7Ir38TXeCW9tN5ADON5YwIDAQAB\",\"coords\":{\"transaction-id\":\"b57376296dc13ef72c509ea8a912bd08fe44317f9374979ad2ddb751a8d48f97\",\"index\":0}},{\"amount\":23,\"address\":\"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApoZWMmLesLbU/mTuknlfJx5n9zk1nUmLjvdgxw4iBB0qlcA0ShENeV1UFb6Jcke2OTZ60FgVE+ku8LE0MTBE9YV4lAd4qE3X1O9NQHWnelhNrnTNQXsRoXLXj9euz9St7fbg8+4lxekpnPGAPDt676TMnvDIHnn0RjuBk+zH97LcRuR/i1pstgiPnCh8TBivLz1/dzGdBZ8dvJ+pBrUuHcPopmclN5BKqjAOW1llqGRFta/JP8br8hq4YmgC37bx/C6T6Z7rawTy8FROaGoIHo4xQuT6zNqDW8HGLPRy70BVP7VJC3iJtpNwjCBnYzUSmjoMPY8vRctSUEIHWwzodwIDAQAB\",\"coords\":{\"transaction-id\":\"b57376296dc13ef72c509ea8a912bd08fe44317f9374979ad2ddb751a8d48f97\",\"index\":1}}]}}")
    end
  end
end
