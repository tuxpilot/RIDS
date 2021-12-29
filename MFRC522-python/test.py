#!/usr/bin/env python
# -*- coding: utf8 -*-

import hashlib

var = 'aaa'
md5_hash = hashlib.md5()
md5_hash.update(var)
print(md5_hash.hexdigest())
