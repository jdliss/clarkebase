require 'rails_helper'
require 'keycleaner_service'

RSpec.describe KeyCleanerService do
  let(:pem_key) {"-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA0kLSxA5CZjocH+Q6jqWR91Cd1z4k59aIgElIgozNlkTlXfBU\n0hgBN1xAhua7xM/Qe6hDDq1Ez/DaEoLDGn/XGjtS9FhdT+KlAvD7G6aW8HTf5MBK\nwwjpLk3gAOSgyHUk1BQPPeUkmHqkOgE9Joxgh6wULKAz/2B6uB2u08X2kBPCaB6z\ndGfIoab92+aVEYuVue4+pb0L9buIHAS+QU8k6jfAySCP+LuofJtcpgDN8tP3r4f2\nrFj9of6RMcaIuPUIBgdtc0ek1fjl3EUSBivBqqynFf2vv5npmiX+O1riT3TxKA+w\nnF497oZhBkITByGb876XkZK02IDvv4AnHxINswIDAQABAoIBAQCQ+PgfrAFGQPzR\nVGi3oBtznYcnOLbzjy0Q3vZ65SB/YsOPML0bGugDxrzLBt4ihnMmP870mK1gfp2t\ns7FYXRrwAEVjKmY0RX4m+Ab7erKJ2tvg+mDR9xvoDFPN6dWeQX8CJ06XC55e7/i5\n8c66/IE2KoTCfDc99sTGm9jGNbGahnTLmarEJOTFHm2R/zOD/P42vUCd/f2mMx1l\nkoChN04+534NO+gvn5EFbNH17GIL0XvJ0VLt7WjsFugeRivcQvmz7gR9wW/0sXcy\nSGugVPNBV43fgAz6wrepcMhpejj7tVy7X/iVDXEf6Uuu1s4nFfimaV3N0RzbUMB/\naaWjASJpAoGBAPV5RVJGCNEm4v9Ty2ttLvbNczFByMYelK+sK6d5WwCsBtwV9Fdc\nmGvlBYGbYLNSYLHWy8MCGLVo7CByFPZ1YC1tdNZvm+smzzw9YvDKYyE5uqBIXaae\nOmodsJl9JE1upNlrmAO6PMpfygCj+LkXXX4ejlv6Sb5NVpr5UILDeNHnAoGBANtG\n/9KUbDrSzdBm6gS/jAKhM9wLPLHpWDFidhvL5x1EiDDgsDioa+h5HjfkbvC4E9NH\nwK3KnvfIlPaRpOFVMLajeW1+io5tttre9HO6YNWRtBpmO6YPv/cRxCjgNoibgEVq\n2Ti0NQ1wDMl8loTf9vhdnB9WOvXOAGz22cFN1URVAoGBAMJhXXtg6ep1GJuHBzXy\nJ5ZX6je/F/WKkcLqW0cq2d0WW/g7ilkDgc8uc8XF/DUDrn4k0QWCy34br5+htufS\n2m4elr6Xcqgq+z+AfLCgEw9kX1w88avW7/rHt+hTKEQIsZFZme6Zszmt0I/hSDuJ\nPQd5utEqyOpg44ukkRR7JVlRAoGBAI5i4COhdVYNJNA6w6MproTWoJI2ScdNOpN2\n2DLciMqcgcMbY9KmqsteOp0YnGF7ZoQ/h4JSnD9R5Ejn8iTP6L3wER1kmhw6ag5d\n0GaFk/OalVS/JeSDPaf1xWa1kTPLpdNtunfzrK95HxSG7kaCGCDWyFYg7FBI4EXh\nVS0MmXuxAoGAIqFD6drqVIhcbw7oyeN/GiFCHofcyjEb36dKVOMffARtSrRPgLMf\nUOXumIQJDGs0jl8dZ4YAZC5KhgF+t6JPbBV+rMUOJdVM4s6+rmoEUAsc1hVTH+Ow\n2EqUCg0KGXE9wo/NqNWIiAz04jsAHS6kK7bH1OP2ynARdgEHxvqR4Nw=\n-----END RSA PRIVATE KEY-----\n"}

  it "it normalizes with normal pem format" do
    private_key = ENV["PRIVATE_KEY"].dup

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key).to eq pem_key
  end

  it "it normalizes with missing header and footer" do
    private_key = pem_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("-----END RSA PRIVATE KEY-----", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key).to eq pem_key
  end

  it "it normalizes with missing new line chars" do
    private_key = pem_key.gsub("\n", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key).to eq pem_key
  end

  it "it normalizes with missing new line chars and missing header/footer" do
    private_key = pem_key.gsub("-----BEGIN RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("-----END RSA PRIVATE KEY-----", "")
    private_key = private_key.gsub("\n", "")

    private_key = KeyCleanerService.clean_user_input(private_key)

    expect(private_key).to eq pem_key
  end
end
