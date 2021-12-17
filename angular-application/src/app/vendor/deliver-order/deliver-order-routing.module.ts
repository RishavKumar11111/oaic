import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DeliverOrderComponent } from './deliver-order.component';

const routes: Routes = [
  {
    path: '',
    component: DeliverOrderComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DeliverOrderRoutingModule { }
