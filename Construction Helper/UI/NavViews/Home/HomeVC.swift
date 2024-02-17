//
//  HomeVC.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit
import Charts

class HomeVC: UIViewController {
    
    @IBOutlet weak var detailedLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    private let viewModel = HomeVM(projectsRepository: ProjectsRepository())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPieChart()
        setupObservers()
        
        self.title = "Construction Helper"
    }
    
    private func setupObservers() {
        
        viewModel.onPieCharDataRetrived.subscribe(with: self) { [weak self] chartData in
            
            guard let weakSelf = self else {return}
            weakSelf.pieChartView.data = chartData
        }
        
        viewModel.onDescriptionChanged.subscribe(with: self) { [weak self] description in
            
            guard let weakSelf = self else {return}
            weakSelf.detailedLabel.text = description
        }
        
        viewModel.onError.subscribe(with: self) { [weak self] error in
            
            guard let weakSelf = self else {return}
            weakSelf.view.subviews.forEach { view in
                view.isHidden = true
            }
            let label = UILabel(frame: weakSelf.view.frame)
            label.text = error
            label.textAlignment = .center
            weakSelf.view.addSubview(label)
        }
        
        viewModel.requestData()
    }

    func setupPieChart() {
        
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.chartDescription.enabled = false
        pieChartView.legend.enabled = false
        
    }


}
