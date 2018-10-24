DATA = {
  'bletchleypark.uk' => [
    'petertwinn',
    'alanturing',
    'gordonwelchman',
    'johnjeffreys',
  ],
  'greenlanterncorps.io' => [
    'alanscott',
    'haljordan',
    'guygardner',
    'johnstewart',
    'kylerayner',
    'abinsur',
    'sinestro',
    'kilowog',
  ],
  'wayneenterprises.com' => [
    'brucewayne',
    'thomaswayne',
    'marthawayne',
    'alfredpennyworth',
    'dickgrayson',
  ],
  'dailyplanet.com' => [
    'perrywhite',
    'clarkkent',
    'loislane',
    'jimmyolsen',
  ],
}

WORDS = [
  "lorem", "ipsum", "dolor", "sit", "ametconsectetur", "adipiscing", "elitsed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore", "magna", "aliquaut", "enim", "ad", "minim", "veniamquis", "nostrud", "exercitation", "ullamco", "laboris", "nisi", "ut", "aliquip", "ex", "ea", "commodo", "consequatduis", "aute", "irure", "dolor", "in", "reprehenderit", "in", "voluptate", "velit", "esse", "cillum", "dolore", "eu", "fugiat", "nulla", "pariaturexcepteur", "sint", "occaecat", "cupidatat", "non", "proidentsunt", "in", "culpa", "qui", "officia", "deserunt", "mollit", "anim", "id", "est", "laborum"
]

EMOJIS = [
  "😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😍", "😘", "😗", "😙", "😚", "☺️", "🙂", "🤗", "🤩", "🤔", "🤨", "😐", "😑", "😶", "🙄", "😏", "😣", "😥", "😮", "🤐", "😯", "😪", "😫", "😴", "😌", "😛", "😜", "😝", "🤤", "😒", "😓", "😔", "😕", "🙃", "🤑", "😲", "☹️", "🙁", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨", "😩", "🤯", "😬", "😰", "😱", "😳", "🤪", "😵", "😡", "😠", "🤬", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "😇", "🤠", "🤡", "🤥", "🤫", "🤭", "🧐", "🤓", "😈", "👿", "👹", "👺", "💀", "👻", "👽", "🤖", "💩", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾"
]

CURRENCIES = ['BTC', 'EUR', 'USD']

def build_transaction
  uuid = SecureRandom.uuid
  source_domain = DATA.keys.shuffle[0]
  source_user = DATA[source_domain].shuffle[0]
  target_domain = DATA.keys.shuffle[0]
  target_user = DATA[target_domain].shuffle[0]
  url = "https://blockchain.io/transactions/#{uuid}"
  amount = "#{(rand * 10_000).to_i},#{(rand * 10_000).to_i}"
  notes = build_text
  currency = CURRENCIES.shuffle[0]
  URLS.push(url)
  {
    "type": "transaction",
    "uuid": uuid,
    "payload": {
      "url": url,
      "source": "#{source_user}@#{source_domain}",
      "target": "#{target_user}@#{target_domain}",
      "amount": "#{amount}",
      "notes": notes,
      "currency": currency,
    }
  }
end

def build_reaction
  uuid = SecureRandom.uuid
  domain = DATA.keys.shuffle[0]
  user = DATA[domain].shuffle[0]
  target_url = URLS.shuffle[0]
  url = "#{target_url}/reactions/#{uuid}"
  reaction = EMOJIS.shuffle[0]
  URLS.push(url)
  {
    type: 'reaction',
    uuid: uuid,
    payload: {
      url: url,
      author: "#{user}@#{domain}",
      target_url: target_url,
      reaction: reaction,
    }
  }
end

def build_text
  length = (rand * 20).to_i + 1
  length.times.map do
    rand > 0.8 ? EMOJIS.shuffle[0] : WORDS.shuffle[0]
  end.join(' ')
end

def build_social_post
  uuid = SecureRandom.uuid
  domain = DATA.keys.shuffle[0]
  user = DATA[domain].shuffle[0]
  content = build_text
  url = "https://#{domain}/#{user}/posts/#{SecureRandom.uuid}"
  URLS.push(url)
  {
    type: 'post',
    uuid: uuid,
    payload: {
      url: url,
      author: "@#{user}",
      content: content
    }
  }
end

def build_action(action:)
  case action
  when :transaction then build_transaction
  when :reaction then build_reaction
  when :social_post then build_social_post
  else
    raise "Action #{action} not supported."
  end
end

def build_batch(size:)
  actions = [
    :transaction,
    :reaction,
    :social_post
  ]
  size.times.map do
    random_action = URLS.size == 0 ? :social_post : actions.shuffle[0]
    build_action(action: random_action)
  end
end
