pub struct ImageDimension {
    pub height: u32,
    pub width: u32,
}

use std::io::Cursor;

use crate::buf_data::BufferedData;

pub fn get_dim(url:String) -> Result<ImageDimension, anyhow::Error> {
    let rq = reqwest::blocking::Client::new();
    let res = rq.get(url).send()?;
    let data = BufferedData {
        buf: Cursor::new(Vec::new()),
        resp: res,
        tmpbuf: vec![],
    };
    let ireader = image::io::Reader::new(data).with_guessed_format()?;
    let dimension = ireader.into_dimensions();
    match dimension {
        Ok(dimension) => Ok(ImageDimension {
            height: dimension.0,
            width: dimension.1,
        }),
        Err(er) => Err(er.into()),
    }
}
