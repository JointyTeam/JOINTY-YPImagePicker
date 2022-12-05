//
//  SelectionsGalleryCell.swift
//  YPImagePicker
//
//  Created by Nik Kov || nik-kov.com on 09.04.18.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
import Stevia

public protocol YPSelectionsGalleryCellDelegate: AnyObject {
    func selectionsGalleryCellDidTapRemove(cell: YPSelectionsGalleryCell)
    func selectionsGalleryCellDidTapReload(cell: YPSelectionsGalleryCell)
}

public class YPSelectionsGalleryCell: UICollectionViewCell {
    
    weak var delegate: YPSelectionsGalleryCellDelegate?
    private let imageView = UIImageView()
    let editIcon = UIView()
    let editSquare = UIView()
    let editImageView = UIImageView(image: YPConfig.icons.editConfigurableImage)
    let removeButton = UIButton()
    let reloadButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        subviews(imageView)
        imageView.subviews(
            editIcon,
            editSquare,
            removeButton,
            reloadButton,
            editImageView
        )
        
        imageView.isUserInteractionEnabled = true

        imageView.CenterY == self.CenterY
        imageView.Left == self.Left
        imageView.Right == self.Right
        
        editImageView.left(12).bottom(12)
        
        editIcon.size(32).left(12).bottom(12)
        editSquare.size(16)
        editSquare.CenterY == editIcon.CenterY
        editSquare.CenterX == editIcon.CenterX
        
        removeButton.top(12).trailing(12)
        reloadButton.bottom(12).trailing(12)
        reloadButton.isHidden = true
        
        imageView.style { i in
            i.clipsToBounds = true
            i.contentMode = .scaleAspectFill
        }
        editIcon.style { v in
            v.backgroundColor = UIColor.ypSystemBackground
            v.layer.cornerRadius = 16
        }
        editSquare.style { v in
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.ypLabel.cgColor
        }
        
        removeButton.setImage(YPConfig.icons.removeImage, for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        reloadButton.setImage(YPConfig.icons.reloadImage, for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func removeButtonTapped() {
        delegate?.selectionsGalleryCellDidTapRemove(cell: self)
    }
    
    @objc
    func reloadButtonTapped() {
        delegate?.selectionsGalleryCellDidTapReload(cell: self)
    }
    
    func setEditable(_ editable: Bool) {
        guard editImageView.image?.size.width ?? 0 == 0 else {
            self.editIcon.isHidden = true
            self.editSquare.isHidden = true
            self.editImageView.isHidden = !editable
            return
        }
        self.editIcon.isHidden = !editable
        self.editSquare.isHidden = !editable
        self.editImageView.isHidden = !editable
    }
    
    func setResetable(_ resetable: Bool) {
        self.reloadButton.isHidden = !resetable
    }
    
    func setImage(_ image: UIImage?) {
        var ratio: CGFloat = 1
        if let size = image?.size {
            ratio = size.width/size.height
        }
        let imageHeight = self.bounds.width/ratio
        if let imageViewHeightConstraint = imageView.heightConstraint {
            imageViewHeightConstraint.constant = imageHeight
        } else {
            imageView.Height == imageHeight
        }
        imageView.image = image
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            if self.isHighlighted {
                                self.transform = CGAffineTransform(scaleX: 0.985, y: 0.985)
                                self.alpha = 0.9
                            } else {
                                self.transform = .identity
                                self.alpha = 1
                            }
            }, completion: nil)
        }
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == removeButton || imageView.frame.contains(point) {
            return view
        }
        return nil
    }
}
