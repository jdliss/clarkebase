task :update_transactions => :environment do
  puts "Updating transactions..."
  Transaction.update_transactions
  puts "done."
end
