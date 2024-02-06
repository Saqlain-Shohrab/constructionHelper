//
//  HomeVM.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 06/02/2024.
//

import Foundation
import Signals
import Charts

class HomeVM {
    
    let onDescriptionChanged = Signal<String>()
    let onPieCharDataRetrived = Signal<PieChartData>()
    
    private let projectsRepository = ProjectsRepository()
    
    func requestData() {
        getProjectsForChart()
    }
    
    private func getProjectsForChart() {
        
        projectsRepository.onProjectsRetrived.subscribe(with: self) { [weak self] projects in
            guard let weakSelf = self, let projects = projects else {return}
            weakSelf.calculatePieChartData(projects: projects)
        }
        
        projectsRepository.requestData()
        
    }
    
    private func calculatePieChartData(projects: [ProjectsModelItemView]) {
        
        var entries: [PieChartDataEntry] = []
        let projectsCount: Int =  projects.count
        let uniqueLocations: Set =  Set(projects.map {$0.location})
        var averageProgress: Double =  0.0

        for project in projects {
            let progress = project.projectProgress
            entries.append(PieChartDataEntry(value: progress, label: "Project \(project.id)"))
            averageProgress += project.projectProgress
        }
        
        averageProgress = averageProgress/Double(projectsCount)

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.material() // Set the slice colors
        dataSet.valueTextColor = .black
        dataSet.valueFont = .systemFont(ofSize: 12)
        dataSet.sliceSpace = 2

        // Optional: add a gradient
        dataSet.yValuePosition = .outsideSlice
        let chartData = PieChartData(dataSet: dataSet)
        
        onPieCharDataRetrived.fire(chartData)
        
        
        let description = "Projects: \(projectsCount) \nUnique locations: \(uniqueLocations.joined(separator: ", ")) \nAverage progress: \(String(format:"%.2f%", averageProgress))%"
        onDescriptionChanged.fire(description)
    }
    
}
