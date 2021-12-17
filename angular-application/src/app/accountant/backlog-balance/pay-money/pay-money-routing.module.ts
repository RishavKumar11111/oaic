import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PayBacklogMoneyComponent } from './pay-backlog-money/pay-backlog-money.component'

const routes: Routes = [
  {
    path: '',
    component: PayBacklogMoneyComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PayMoneyRoutingModule { }
