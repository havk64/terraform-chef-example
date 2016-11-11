file '/tmp/motd' do
  content <<-EOF.gsub(/^ {4}/, '')
    Hello, World!
    Playing around with heredoc...
    Thanks for watching!
    EOF
end
