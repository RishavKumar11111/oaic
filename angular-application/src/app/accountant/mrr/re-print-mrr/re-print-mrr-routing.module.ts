import { RePrintMrrComponent } from './re-print-mrr/re-print-mrr.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    component: RePrintMrrComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class RePrintMrrRoutingModule { }
