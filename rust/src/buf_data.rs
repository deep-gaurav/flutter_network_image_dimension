use std::io::{BufRead, Cursor, Read, Seek, SeekFrom, Write};

use reqwest::blocking::Response;

pub struct BufferedData {
    pub buf: Cursor<Vec<u8>>,
    pub tmpbuf: Vec<u8>,
    pub resp: Response,
}
impl Read for BufferedData {
    fn read(&mut self, buf: &mut [u8]) -> std::io::Result<usize> {
        println!("reading bufs {}", buf.len());
        let read = self.buf.read(buf)?;
        let remaining = buf.len() - read;

        let r = self.resp.read(&mut buf[read..]);
        match r {
            Ok(d) => {
                self.buf.write(&buf[read..read + d])?;
                println!("Read {d}");
                Ok(d + read)
            }
            Err(err) => Err(err),
        }
    }
}

impl Seek for BufferedData {
    fn seek(&mut self, pos: std::io::SeekFrom) -> std::io::Result<u64> {
        println!("seeking {:#?}", pos);
        self.buf.seek(pos)
    }
}

impl BufRead for BufferedData {
    fn fill_buf(&mut self) -> std::io::Result<&[u8]> {
        println!("filling");

        let mut tmpbuf = [0u8; 8000];
        let amt = self.read(&mut tmpbuf)?;
        self.seek(SeekFrom::Current(-(amt as i64)))?;
        self.tmpbuf.clear();
        self.tmpbuf.extend(&tmpbuf[..amt]);
        Ok(&self.tmpbuf)
    }

    fn consume(&mut self, amt: usize) {
        println!("consuming");
        self.seek(SeekFrom::Current(amt as i64));
    }
}
