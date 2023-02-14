class User < ApplicationRecord
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy

    # 対象のuserが存在する場合はuser情報を返し、存在しない場合は新規作成の処理を行う
    def self.from_token_payload(payload)
        find_by(sub: payload['sub']) || create!(sub: payload['sub'], name: payload['.name'], email: payload['.email'], picture: payload['.picture'])
    end
end
