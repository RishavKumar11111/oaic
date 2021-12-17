import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { WithheldAmountComponent } from './withheld-amount.component';

const routes: Routes = [
  {
    path: '',
    component: WithheldAmountComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class WithheldAmountRoutingModule { }
