import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { WithheldAmountComponent } from './withheld-amount.component';

describe('WithheldAmountComponent', () => {
  let component: WithheldAmountComponent;
  let fixture: ComponentFixture<WithheldAmountComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WithheldAmountComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WithheldAmountComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
