# @file POSet.py
# @brief Partially-ordered sets.
# @author weaves
#
# @details
# This class provides some generators for partially-ordered sets.
#
# @note:
# 

import logging
import socket
import struct

# logging.basicConfig(filename='POSet.log', level=logging.DEBUG)
logger = logging.getLogger('POSet')
# sh = logging.StreamHandler()
# logger.addHandler(sh)


## Helper methods
# These methods are the ones being ported to Cython.

## End Helper Methods

class Impl(object):
  """
  Multicast support class.

  This is accessed via a Singleton known as MCast
  """

  _logger = logging.getLogger('weaves')
  """Interface with logging"""

  def __init__(self, **kwargs):
    pass

  def make(self, **kwargs):
    if "socket" in kwargs and kwargs["socket"].startswith("mcast"):
      broadcast="239.255.255.250"
      port=1910
      self._logger.info("socket")

      addrinfo = socket.getaddrinfo(broadcast, None)[0]
      sock = socket.socket(addrinfo[0], socket.SOCK_DGRAM)
      sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
      ## An error
      # sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)

      group_bin = socket.inet_pton(addrinfo[0], addrinfo[4][0])
      if addrinfo[0] == socket.AF_INET: # IPv4
        sock.bind(('', port))
        mreq = group_bin + struct.pack('=I', socket.INADDR_ANY)
        sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, mreq)
      else:
        sock.bind(('', port))
        mreq = group_bin + struct.pack('@I', 0)
        sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_JOIN_GROUP, mreq)

      return sock


class Singleton(object):
  """
  Single instance of L{Impl} this provides access to the implementation.
  """
  _impl = None
  
  @classmethod
  def instance(cls):
    if cls._impl is None:
      cls._impl =  Impl()

    return cls._impl
