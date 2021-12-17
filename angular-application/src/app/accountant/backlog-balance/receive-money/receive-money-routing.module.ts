import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ReceiveBacklogMoneyComponent } from './receive-backlog-money/receive-backlog-money.component';

const routes: Routes = [
  {
    path: '',
    component: ReceiveBacklogMoneyComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReceiveMoneyRoutingModule { }
