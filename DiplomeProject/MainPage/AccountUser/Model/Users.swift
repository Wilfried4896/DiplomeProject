
import Foundation

struct Account {
    var name: String
    var image: String
    var occupation: String
    var city: String
    var photoUser: [PhotoUser]
    var gallery: [Gallerie]
    var post: [Posts]
}

struct PhotoUser {
    var name: String
}

struct Gallerie {
    var name: String
    var album: [PhotoUser]
}

struct Posts {
    var text: String
    var publishDate: String
    var image: String
}


struct Users {
    
    static let shared = Users()

    private init() { }

    let followers: [Account] = [
        Account(name: "Yves de la Tours",
                image: "Yves",
                occupation: "Development Management",
                city: "Moscou",
                photoUser: [
                    PhotoUser(name: "images-10"),
                    PhotoUser(name: "images-3"),
                    PhotoUser(name: "images-9"),
                    PhotoUser(name: "images-13"),
                    PhotoUser(name: "images-7"),
                    PhotoUser(name: "images-20"),
                    PhotoUser(name: "images-18")
                ],
                gallery: [
                    Gallerie(name: "Party", album: [
                        PhotoUser(name: "images-9"),
                        PhotoUser(name: "images-13"),
                        PhotoUser(name: "images-7"),
                        PhotoUser(name: "images-20"),
                    ]),
                    Gallerie(name: "Other", album: [
                        PhotoUser(name: "images-2"),
                        PhotoUser(name: "images-3"),
                        PhotoUser(name: "images-4"),
                    ])
                ],
                post: [
                    Posts(text: "Adept, a startup training AI to use existing software and APIs, has raised $350 million in a funding round, reportedly at an over-$1 billion valuation.",
                          publishDate: "2023-03-15T20:56:44",
                          image: "https://techcrunch.com/wp-content/uploads/2022/09/GettyImages-947742868.jpg?resize=1200,800"),
                    Posts(text: "The FTC slammed Epic Games with $245 million in fines this week over misleading dark pattern design and kids' privacy protections.",
                          publishDate: "2023-03-16T04:44:46",
                          image: "https://techcrunch.com/wp-content/uploads/2020/08/fortnite-epic-GettyImages-957063528.jpg?resize=1200,800")
                ]
            ),
        
        Account(name: "Anna Laure",
                image: "laure-valee",
                occupation: "Development iOS",
                city: "New York",
                photoUser: [
                    PhotoUser(name: "images-2"),
                    PhotoUser(name: "images-3"),
                    PhotoUser(name: "images-4"),
                    PhotoUser(name: "images-5"),
                    PhotoUser(name: "images-6"),
                    PhotoUser(name: "images-7"),
                    PhotoUser(name: "images-8"),
                    PhotoUser(name: "images-9")
                ],
                gallery: [
                    Gallerie(name: "Movies", album: [
                        PhotoUser(name: "images-12"),
                        PhotoUser(name: "images-13"),
                        PhotoUser(name: "images-14"),
                        PhotoUser(name: "images-15"),
                    ]),
                    Gallerie(name: "City", album: [
                        PhotoUser(name: "images-14"),
                        PhotoUser(name: "images-20"),
                        PhotoUser(name: "images-8"),
                        PhotoUser(name: "images")
                    ])
                ],
                post: [
                    Posts(text: "VW’s new ID.2all concept shows what the future could hold for wallet-friendly EVs... in Europe.\nThe post The ID.2all Concept Previews VW’s Dream for Affordable EVs appeared first on Gizmodo Australia.\n  Related Stories",
                          publishDate: "2023-03-16T04:48:57",
                          image: "https://www.gizmodo.com.au/wp-content/uploads/sites/2/2023/03/16/72b2a1acff321647f9fcf04a1919e75d.jpg?quality=80&resize=1280,720"),
                    Posts(text: "We’ve all been there. Maybe you were neck-deep in a work project, or you hopped too far down a Wikipedia rabbit hole, but at a certain point you looked up and realized you were drowning in a mess of browser tabs, with no clear way to put them all in order",
                          publishDate: "2023-03-15T15:00:11",
                          image: "https://s.yimg.com/uu/api/res/1.2/c0MqB1wzKG1MssC.TB0A4Q--~B/Zmk9ZmlsbDtoPTYzMDtweW9mZj0wO3c9MTIwMDthcHBpZD15dGFjaHlvbg--/https://media-mbst-pub-ue1.s3.amazonaws.com/creatr-uploaded-images/2023-03/a92e30e0-bf7c-11ed-bccf-063fef733785.cf.jpg"),
                    Posts(text: "Apple released its latest ad for its popular headphones. The one-minute commercial uses a creative metropolitan visualization to tout how well the wireless headphones block out external sounds with improved active noise cancellation",
                          publishDate: "2023-03-15T13:40:00",
                          image: "https://i0.wp.com/9to5mac.com/wp-content/uploads/sites/6/2023/03/apple-airpods-pro-2-ad.jpeg?resize=1200%2C628&quality=82&strip=all&ssl=1")
                ]
            ),
        
        Account(name: "John Wick",
                image: "john-wick",
                occupation: "Actor",
                city: "Google",
                photoUser: [
                    PhotoUser(name: "images-10"),
                    PhotoUser(name: "images-11"),
                    PhotoUser(name: "images-12"),
                    PhotoUser(name: "images-13"),
                    PhotoUser(name: "images-14"),
                    PhotoUser(name: "images-15"),
                    PhotoUser(name: "images-16"),
                ],
                gallery: [
                    Gallerie(name: "Moscou", album: [
                        PhotoUser(name: "images-12"),
                        PhotoUser(name: "images-13"),
                        PhotoUser(name: "images-14"),
                        PhotoUser(name: "images-15"),
                    ]),
                    Gallerie(name: "Country", album: [
                        PhotoUser(name: "images-14"),
                        PhotoUser(name: "images-20"),
                        PhotoUser(name: "images-8"),
                        PhotoUser(name: "images")
                    ])
                ],
                post: [
                    Posts(text: "Dallas-based infrastructure manufacturer Arcosa (NYSE: ACA) said today that it’s received $750 million worth of wind turbine tower orders, so it’s building a new factory where it can make them.\n more…\nThe post A new factory in New Mexico will build $750M",
                          publishDate: "2023-03-16T00:51:41",
                          image: "https://i0.wp.com/electrek.co/wp-content/uploads/sites/3/2023/03/arcosa-wind-turbine-towers.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1"),
                ]
            ),
        
        Account(name: "The Life",
                image: "moscou",
                occupation: "Microsoft Founder",
                city: "Paris",
                photoUser: [
                    PhotoUser(name: "images-18"),
                    PhotoUser(name: "images-19"),
                    PhotoUser(name: "images-20"),
                    PhotoUser(name: "images"),
                    PhotoUser(name: "images-1"),
                    PhotoUser(name: "images-2"),
                    PhotoUser(name: "images-3"),
                    PhotoUser(name: "images-4")
                ],
                gallery: [
                    Gallerie(name: "Vacation", album: [
                        PhotoUser(name: "images-2"),
                        PhotoUser(name: "images-3"),
                        PhotoUser(name: "images-4"),
                        PhotoUser(name: "images-5"),
                    ]),
                    Gallerie(name: "In USA", album: [
                        PhotoUser(name: "images-17"),
                        PhotoUser(name: "images-9"),
                        PhotoUser(name: "images-18"),
                    ])
                ],
                post: [
                    Posts(text: "The bank is weighing various options after being caught in the turbulence of Silicon Valley Bank's collapse.",
                          publishDate: "2023-03-16T00:22:26",
                          image: "https://thehill.com/wp-content/uploads/sites/2/2023/02/84ac89c4c43e4130be908212a537e274.jpg?w=1280"),
                    Posts(text: "Crash testing is an important part of automotive development. It helps carmakers understand how varying impacts will affect passengers, and...\nThe post U.S. Crash Test Dummies Don’t Reflect the Population, Report Claims appeared first on Gizmodo Australia.\n",
                          publishDate: "2023-03-16T00:17:43",
                          image: "https://www.gizmodo.com.au/wp-content/uploads/sites/2/2023/03/16/6f723ab0d8744c813725d93d152ea388.jpg?quality=80&resize=1280,720")
                ]
            ),
     ]
}
