class AddXmlToChannels < ActiveRecord::Migration
  def change
    # binary datatype is necessary for correct storing and handling of different encodings
    # (for example http://www.vz.ru/rss.xml is marked to be encoded with windows-1251)
    # and response.body.encoding for it returns ASCII-8BIT encoding.
    # Wasn't able to make it work with datatype :text and usinf String#encoding and force_encoding
    add_column :channels, :xml, :binary
  end
end
