import asyncio


class EchoServerProtocol:
    def connection_made(self, transport):
        self.transport = transport

    def datagram_received(self, data, addr):
        message = data.decode()
        print('Received %r from %s' % (message, addr))
        print('Send %r to %s' % (message, addr))
        self.transport.sendto(data, addr)


async def main():
    print("Starting UDP server")

    # Get a reference to the event loop as we plan to use
    # low-level APIs.
    loop = asyncio.get_running_loop()

    # One protocol instance will be created to serve all
    # client requests.
    transport, protocol = await loop.create_datagram_endpoint(
        lambda: EchoServerProtocol(),
        local_addr=('127.0.0.1', 32460))

    try:
        await asyncio.sleep(3600)  # Serve for 1 hour.
    finally:
        transport.close()


asyncio.run(main())

asyncio.run(main())

##  Local Variables:
##  mode:python
##  mode:outline-minor
##  mode:auto-fill
##  outline-regexp: "## *\\([A-Za-z]\\|[IVXivx0-9]+\\)\\. *"
##  python-shell-interpreter: "ipython"
##  fill-column: 75
##  comment-column:50
##  comment-start: "##  "
##  comment-end:""
##  End: