require File.dirname(__FILE__) + '/fixtures/classes'
require File.dirname(__FILE__) + '/../../spec_helper'

describe "UDPSocket.open" do

  after(:each) do
    @socket.close if @socket
    @server.close if @server
  end

  it "returns a socket that can be written to and read from" do
    @ready = false
    server_thread = Thread.new do
      @server = UDPSocket.open
      @server.bind(nil,SocketSpecs.port)
      @ready = true
      msg1 = @server.recvfrom(64)
      msg1[0].should == "ad hoc"
      msg1[1][0].should == "AF_INET"
      (msg1[1][1].kind_of? Fixnum).should == true
      msg1[1][3].should == "127.0.0.1"

      msg2 = @server.recvfrom(64)
      msg2[0].should == "connection-based"
      msg2[1][0].should == "AF_INET"
      (msg2[1][1].kind_of? Fixnum).should == true
      msg2[1][3].should == "127.0.0.1"
    end

    Thread.pass until @ready

    UDPSocket.open.send("ad hoc", 0, 'localhost',SocketSpecs.port)

    @socket = UDPSocket.open
    @socket.connect('localhost',SocketSpecs.port)
    @socket.send("connection-based", 0)

    server_thread.join
  end
end
