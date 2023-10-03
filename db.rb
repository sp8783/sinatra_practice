# frozen_string_literal: true

require 'pg'

def conn
  @conn ||= PG.connect(dbname: 'postgres')
end

def create_table
  result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)') if result.values.empty?
end

def load_all_memos
  result = conn.exec('SELECT * FROM memos')
  result.map { |memo| memo.transform_keys(&:to_sym) }
end

def load_memo_by_id(id)
  result = conn.exec('SELECT * FROM memos WHERE id = $1;', [id])
  result[0].transform_keys(&:to_sym)
end

def add_memo(memo)
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', memo.values)
end

def update_memo(memo)
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', memo.values)
end

def delete_memo(id)
  conn.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end
