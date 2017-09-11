module CategorySerializer
  class Base < ActiveModel::Serializer
    attributes :id, :title, :applications

    private

    # rubocop:disable all
    def applications_data
      [
        {
          id: 1,
          title: "Flowdesk",
          description: "Fashion axe pabst 3 wolf moon slow-carb diy cardigan wolf ethical.",
          logo: "https://robohash.org/reiciendisdoloresdeserunt.png?size=300x300&set=set1"
        },
        {
          id: 2,
          title: "Bitwolf",
          description: "Vinyl roof flexitarian leggings.",
          logo: "https://robohash.org/aperiamvoluptatemmaxime.png?size=300x300&set=set1"
        },
        {
          id: 3,
          title: "Otcom",
          description: "Tote bag iphone celiac bespoke vice occupy fashion axe.",
          logo: "https://robohash.org/oditsuscipitnon.png?size=300x300&set=set1"
        },
        {
          id: 4,
          title: "Voltsillam",
          description: "Phlogiston intelligentsia 90's offal hammock aesthetic photo booth art party.",
          logo: "https://robohash.org/nemoipsamconsequuntur.png?size=300x300&set=set1"
        },
        {
          id: 5,
          title: "Regrant",
          description: "Pop-up quinoa literally craft beer intelligentsia chambray fingerstache shabby chic leggings.",
          logo: "https://robohash.org/voluptatesevenietut.png?size=300x300&set=set1"
        },
        {
          id: 6,
          title: "Daltfresh",
          description: "Hella +1 cornhole tousled.",
          logo: "https://robohash.org/eostenetursuscipit.png?size=300x300&set=set1"
        },
        {
          id: 7,
          title: "Konklux",
          description: "Locavore tumblr brooklyn shoreditch pabst diy synth.",
          logo: "https://robohash.org/rationequibusdamquis.png?size=300x300&set=set1"
        },
        {
          id: 8,
          title: "Ventosanzap",
          description: "Phlogiston leggings tumblr messenger bag mlkshk readymade banh mi tattooed distillery.",
          logo: "https://robohash.org/sedautdolores.png?size=300x300&set=set1"
        },
        {
          id: 9,
          title: "Viva",
          description: "3 wolf moon kitsch etsy gastropub.",
          logo: "https://robohash.org/teneturquamdoloremque.png?size=300x300&set=set1"
        }
      ]
    end
  end
end
