import asyncio
import logging
import socket
import struct
import queue

BROADCAST_PORT = 1910
BROADCAST_ADDR = "239.255.255.250"
#BROADCAST_ADDR = "ff0e::10"

q0 = queue.Queue()

class MulticastServerProtocol(asyncio.DatagramProtocol):

    cnt0 = 0

    def connection_made(self, transport):
        self.transport = transport

    def datagram_received(self, data, addr):
        self.cnt0+=1
        print('Received {} {!r} from {!r}'.format(self.cnt0, data, addr))
        self.transport.sendto(data, addr)
        q0.put_nowait(data)

loop = asyncio.get_event_loop()
loop.set_debug(True)
logging.basicConfig(level=logging.DEBUG)

addrinfo = socket.getaddrinfo(BROADCAST_ADDR, None)[0]
sock = socket.socket(addrinfo[0], socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
# An error
# sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)

group_bin = socket.inet_pton(addrinfo[0], addrinfo[4][0])
if addrinfo[0] == socket.AF_INET: # IPv4
    sock.bind(('', BROADCAST_PORT))
    mreq = group_bin + struct.pack('=I', socket.INADDR_ANY)
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)
else:
    sock.bind(('', BROADCAST_PORT))
    mreq = group_bin + struct.pack('@I', 0)
    sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_JOIN_GROUP, mreq)



listen = loop.create_datagram_endpoint(
    MulticastServerProtocol,
    sock=sock,
)
transport, protocol = loop.run_until_complete(listen)

loop.run_forever()
loop.close()

