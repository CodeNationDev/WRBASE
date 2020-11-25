import UIKit

public class NavigationBarTitleView: UIView {

    // MARK: - Custom
    public init(title: String?) {
        super.init(frame: .zero)
        setup(title: title)
    }

    public init(image: UIImage?) {
          super.init(frame: .zero)
          setup(image: image)
      }

    // MARK: - Override
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.tintColor = .genericWhite
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 22)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        translatesAutoresizingMaskIntoConstraints = false
    }

    func setup(title: String? = nil) {

         let stackView: UIStackView = {
                    let stackview = UIStackView()
                    stackview.axis = .vertical
                    return stackview
                }()

                if let title = title {
                    let titleLabel: UILabel = {
                        let titleLabel = UILabel()
                        titleLabel.textColor = .genericWhite
                        titleLabel.font = .openSansRegular(size: 18)
                        titleLabel.textAlignment = .center
                        titleLabel.text = title
                        return titleLabel
                    }()
                    titleLabel.translatesAutoresizingMaskIntoConstraints = false
                    stackView.addArrangedSubview(titleLabel)
                    titleLabel.clipsToBounds = true
                }

                stackView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        translatesAutoresizingMaskIntoConstraints = false
    }
}

