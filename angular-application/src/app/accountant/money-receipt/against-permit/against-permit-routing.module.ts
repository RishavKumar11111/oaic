import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AgainstPermitComponent } from './against-permit/against-permit.component';

const routes: Routes = [
  {
    path: '',
    component: AgainstPermitComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AgainstPermitRoutingModule { }
