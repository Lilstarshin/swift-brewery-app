//
//  BeerListCell.swift
//  Brewery
//
//  Created by 신새별 on 2022/03/22.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell: UITableViewCell {
  let beerImageView = UIImageView()
  let nameLabel = UILabel()
  let taglineLabel = UILabel()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    [beerImageView, nameLabel, taglineLabel].forEach { e in
      contentView.addSubview(e)
      
    }
    beerImageView.contentMode = .scaleAspectFit
    nameLabel.numberOfLines = 2
    
    taglineLabel.font = .systemFont(ofSize: 14, weight: .light)
    taglineLabel.textColor = .systemBlue
    taglineLabel.numberOfLines = 0
    
    beerImageView.snp.makeConstraints { e in
      e.centerY.equalToSuperview()
      e.leading.top.bottom.equalToSuperview().inset(20)
      e.width.equalTo(80)
      e.height.equalTo(120)
    }
    
    nameLabel.snp.makeConstraints { e in
      e.leading.equalTo(beerImageView.snp.trailing).offset(10)
      e.bottom.equalTo(beerImageView.snp.centerY)
      e.trailing.equalToSuperview().inset(20)
    }
    taglineLabel.snp.makeConstraints { e in
      e.leading.trailing.equalTo(nameLabel)
      e.top.equalTo(nameLabel.snp.bottom).offset(5)
    }
    
  }
  func configure(with beer: Beer) {
    let imageURL = URL(string: beer.imageURL ?? "")
    
    beerImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))
    nameLabel.text = beer.name ?? "이름 없는 맥주"
    taglineLabel.text = beer.tagLine
    
    accessoryType = .disclosureIndicator
    selectionStyle = .none
  }
}
