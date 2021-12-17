import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DeliverReportComponent } from './deliver-report.component';

const routes: Routes = [
  {
    path: '',
    component: DeliverReportComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DeliverReportRoutingModule { }
