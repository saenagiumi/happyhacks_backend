class User < ApplicationRecord
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :bookmarks, dependent: :destroy
    has_many :liked_comments, through: :likes, source: :comment
    has_many :bookmarked_comments, through: :bookmarks, source: :comment

    validates_uniqueness_of :sub

    # 対象のuserが存在する場合はuser情報を返す
    def self.from_token_payload(payload)
        find_by(sub: payload['sub'])
    end
end
