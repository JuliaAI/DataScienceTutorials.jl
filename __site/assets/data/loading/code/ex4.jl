# This file was generated, do not modify it. # hide
c = """
col1,col2,col3,col4,col5,col6,col7,col8
,1,1.0,1,one,2019-01-01,2019-01-01T00:00:00,true
,2,2.0,2,two,2019-01-02,2019-01-02T00:00:00,false
,3,3.0,3.14,three,2019-01-03,2019-01-03T00:00:00,true
"""
fpath, = mktemp()
write(fpath, c);