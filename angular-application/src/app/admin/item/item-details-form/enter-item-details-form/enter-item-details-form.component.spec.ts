import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { EnterItemDetailsFormComponent } from './enter-item-details-form.component';

describe('EnterItemDetailsFormComponent', () => {
  let component: EnterItemDetailsFormComponent;
  let fixture: ComponentFixture<EnterItemDetailsFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EnterItemDetailsFormComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EnterItemDetailsFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
