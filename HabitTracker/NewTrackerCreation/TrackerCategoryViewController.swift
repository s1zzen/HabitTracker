//
//  TrackerCategoryViewController.swift
//  HabitTracker
//
//  Created by Сергей Баскаков on 28.07.2024.
//

import UIKit

// MARK: - CategoryViewDelegate

protocol TrackerCategoryViewModelDelegate: AnyObject {
    func updateData(nameCategory: String)
}

// MARK: - CategoryViewController

final class TrackerCategoryViewController: UIViewController {
    var viewModel: TrackerCategoryViewModel?

    // MARK: - UiElements

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var habitLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var mainStarImageStub: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Error1"))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var descriptionPlaceholderStub: UILabel = {
        let label = UILabel()
        label.text = "Habits and events can be\ncombined in meaning"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var creatingHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add category", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.actionsForButton), for: .touchUpInside)
        return button
    }()

    func initialize(viewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        bind()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configConstraints()
        checkForAvailableCategories()
        try? viewModel?.fetchACategory()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let categories = viewModel?.categories,
              categories.isEmpty else { return }
    }

    // MARK: Binding
    private func bind() {
        viewModel?.$categories.bind(action: { [weak self] _ in
            self?.checkForAvailableCategories()
        })
    }

    // MARK: - Actions

    @objc
    func actionsForButton() {
        let createCategoryViewController = CreatingCategoryViewController()
        createCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createCategoryViewController)
        present(navigationController, animated: true)
    }

    // MARK: - Private methods

    private func checkForAvailableCategories() {
        tableView.reloadData()
        guard let category = viewModel?.categories else { return }
        if !category.isEmpty {
            placeholderDisplaySwitch(isHiden: true)
            configThereAreCategories()
        } else {
            placeholderDisplaySwitch(isHiden: false)
        }
    }

    private func placeholderDisplaySwitch(isHiden: Bool) {
        mainStarImageStub.isHidden = isHiden
        descriptionPlaceholderStub.isHidden = isHiden
    }

    private func configViews() {
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .ypWhiteDay
        view.addSubview(habitLabel)
        view.addSubview(creatingHabitButton)
        view.addSubview(mainStarImageStub)
        view.addSubview(descriptionPlaceholderStub)
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            habitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            mainStarImageStub.widthAnchor.constraint(equalToConstant: 80),
            mainStarImageStub.heightAnchor.constraint(equalToConstant: 80),
            mainStarImageStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStarImageStub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            descriptionPlaceholderStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionPlaceholderStub.topAnchor.constraint(equalTo: mainStarImageStub.bottomAnchor, constant: 8),
            creatingHabitButton.heightAnchor.constraint(equalToConstant: 60),
            creatingHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            creatingHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            creatingHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func configThereAreCategories() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: habitLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: creatingHabitButton.topAnchor, constant: -38)
        ])
    }
}

// MARK: - UITableViewDelegate

extension TrackerCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editingIndexPath = viewModel?.loadIndexPathForCheckmark() {
            let previousSelectedCell = tableView.cellForRow(at: editingIndexPath)
            previousSelectedCell?.accessoryType = .none
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        viewModel?.selectedCategoryForCheckmark(indexPath)
        viewModel?.addingCategoryToCreate(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let deleteAction = UIAction(title: "Delete", attributes: .destructive) { [weak self] _ in
            guard let self = self else { return }
            try? self.viewModel?.removeACategory(atIndex: indexPath.row)
            self.checkForAvailableCategories()
        }
        let deleteMenu = UIMenu(title: "", children: [deleteAction])
        return UIContextMenuConfiguration(actionProvider: { _ in
            deleteMenu
        })
    }
}

// MARK: - UITableViewDataSource

extension TrackerCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.categoriesCount() else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        guard let count = viewModel?.categoriesCount() else { return UITableViewCell() }
        cell.textLabel?.text = viewModel?.categories[indexPath.row].title
        cell.textLabel?.textColor = .ypBlackDay
        cell.backgroundColor = .backgroundDay
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        cell.separatorInset = separatorInsetForCell(index: indexPath.row, numberOfLines: count)
        cell.layer.maskedCorners = roundingForCellsInATable(cellIndex: indexPath.row, numberOfLines: count)
        cell.accessoryType = indexPath == viewModel?.loadIndexPathForCheckmark() ? .checkmark : .none
        return cell
    }
}

// MARK: - ConfigForCell

extension TrackerCategoryViewController {
    func roundingForCellsInATable(cellIndex: Int, numberOfLines: Int) -> CACornerMask {
        switch (cellIndex, numberOfLines) {
        case (0, 1):
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (0, _):
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (_, _) where cellIndex == numberOfLines - 1:
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            return []
        }
    }

    func separatorInsetForCell(index: Int, numberOfLines: Int) -> UIEdgeInsets {
        let quantityCategory = numberOfLines - 1
        if index == quantityCategory {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

// MARK: - CreateCategoryViewDelegate

extension TrackerCategoryViewController: TrackerCategoryViewModelDelegate {
    func updateData(nameCategory: String) {
        try? viewModel?.createACategory(nameOfCategory: nameCategory)
        try? viewModel?.fetchACategory()
    }
}
