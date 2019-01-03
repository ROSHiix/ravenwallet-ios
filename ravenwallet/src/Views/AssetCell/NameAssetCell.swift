//
//  DescriptionSendCell.swift
//  ravenwallet
//
//  Created by Adrian Corscadden on 2016-12-16.
//  Copyright © 2018 Ravenwallet Team. All rights reserved.
//

import UIKit

class NameAssetCell : NameAddressCell {

    var didVerifyTapped: ((String?) -> Void)?

    let verify = ShadowButton(title: S.Asset.verifyLabel, type: .secondary)
    let activityView = UIActivityIndicatorView(style: .white)
    let verifyResult = UILabel(font: UIFont.customBody(size: 14.0))

    override func setupViews() {
        addSubviews()
        addConstraints()
        addButtonActions()
    }
    
    private func addSubviews() {
        addSubview(textField)
        textField.addSubview(placeholder)
        addSubview(verifyResult)
        addSubview(verify)
        verify.addSubview(activityView)
    }
    
    private func addConstraints() {
        textField.constrain([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11.0),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 30.0),
            textField.trailingAnchor.constraint(equalTo: verifyResult.trailingAnchor, constant: -C.padding[2]) ])
        
        placeholder.constrain([
            placeholder.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            placeholder.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 5.0) ])
        
        verify.constrain([
            verify.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.padding[2]),
            verify.topAnchor.constraint(equalTo: topAnchor, constant: C.padding[2])])
        
        activityView.constrain([
            activityView.centerXAnchor.constraint(equalTo: verify.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: verify.centerYAnchor)])
        
        verifyResult.constrain([
            verifyResult.trailingAnchor.constraint(equalTo: verify.leadingAnchor, constant: -C.padding[2]),
            verifyResult.centerYAnchor.constraint(equalTo: verify.centerYAnchor)])
    }
    
    private func addButtonActions() {
        verify.addTarget(self, action: #selector(NameAssetCell.verifyTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(NameAssetCell.removeText))
        verifyResult.isUserInteractionEnabled = true
        verifyResult.addGestureRecognizer(tap)
    }
    
    override func setInitialData() {
        super.setInitialData()
        verifyResult.isHidden = true
        activityView.hidesWhenStopped = true
        activityView.stopAnimating()
    }
    
    @objc func removeText(sender:UITapGestureRecognizer){
        self.textField.text = ""
        textField.textColor = .darkText
        verifyResult.isHidden = true
    }

    @objc func verifyTapped() {
        activityView.startAnimating()
        verify.label.isHidden = true
        verifyResult.isHidden = false
        verifyResult.attributedText = NSAttributedString(string: "")
        self.didVerifyTapped!(self.textField.text)
    }
    
    func checkAvailabilityResult(isFound:Bool) {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.verify.label.isHidden = false
            self.verifyResult.attributedText = self.getVerifyResultString(isFound: isFound)
            self.textField.textColor = isFound ? .red : .receivedGreen
        }
    }
    
    func getVerifyResultString(isFound:Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        let icon = NSTextAttachment()
        icon.bounds = CGRect(x: 0, y: -2.0, width: 24.0, height: 24.0)
        let iconString = NSMutableAttributedString(string: S.Symbols.narrowSpace) // space required before an attachment to apply template color (UIKit bug)
        if isFound == false {
            icon.image = #imageLiteral(resourceName: "CircleCheckSolid").withRenderingMode(.alwaysTemplate)
            iconString.append(NSAttributedString(attachment: icon))
            attributedString.insert(iconString, at: 0)
            attributedString.addAttributes([.foregroundColor: UIColor.receivedGreen,
                                            .font: UIFont.customBody(size: 0.0)],
                                           range: NSMakeRange(0, iconString.length))
        } else {
            icon.image = #imageLiteral(resourceName: "deletecircle").withRenderingMode(.alwaysTemplate)
            iconString.append(NSAttributedString(attachment: icon))
            attributedString.insert(iconString, at: 0)
            attributedString.addAttributes([.foregroundColor: UIColor.sentRed,
                                            .font: UIFont.customBody(size: 0.0)],
                                           range: NSMakeRange(0, iconString.length))
        }
        return attributedString
    }
}

extension NameAssetCell {
    
    @objc override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        textField.textColor = .darkText
        verifyResult.isHidden = true
    }
    
}
