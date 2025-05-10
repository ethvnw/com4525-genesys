import { Controller } from '@hotwired/stimulus';

/* A Stimulus controller for handling the addition and deletion of booking references for plans.
To use, include the following elements:
  data-controller="booking-references" - Calls the controller
  data-booking-references-target="name" - The input field for the reference name
  data-booking-references-target="number" - The input field for the reference number
  data-booking-references-target="dataField" - The hidden input field, storing the refs as JSON
  data-booking-references-target="tbody" - The table body element where the refs are displayed
  data-booking-references-target="table" - The table element that contains the refs
  data-booking-references-target="warning" - The span element that displays warning messages
*/

export default class extends Controller {
  static get targets() {
    return ['name', 'number', 'dataField', 'tbody', 'table', 'warning'];
  }

  connect() {
    this.references = [];
    this.loadFromField(); // Load existing references if they exist.
    this.render();
  }

  // Add a new reference to the list
  addReference() {
    const name = this.nameTarget.value.trim();
    const number = this.numberTarget.value.trim();

    this.showWarning(''); // Clear previous warnings

    if (!name || !number) return;

    // Check if the reference already exists (both name and number)
    if (this.references.some((ref) => ref.name === name)) {
      this.showWarning('A booking reference with this name already exists.');
      return;
    } if (this.references.some((ref) => ref.number === number)) {
      this.showWarning('A booking reference with this reference number already exists.');
      return;
    } if (this.references.length >= 10) {
      this.showWarning('You can only add up to 10 booking references.');
      return;
    }

    this.references.push({ name, number });
    this.updateField();
    this.render();

    this.nameTarget.value = '';
    this.numberTarget.value = '';
  }

  // Remove a reference from the list
  deleteReference(event) {
    const { index } = event.currentTarget.dataset;
    this.references.splice(index, 1);
    this.updateField();
    this.render();
  }

  render() {
    this.tbodyTarget.innerHTML = '';

    if (this.references.length <= 0) {
      this.tableTarget.classList.add('d-none');
    } else {
      this.tableTarget.classList.remove('d-none');

      this.references.forEach((ref, index) => {
        const row = document.createElement('tr');

        const nameCell = document.createElement('td');
        nameCell.textContent = ref.name;

        const numberCell = document.createElement('td');
        numberCell.textContent = ref.number;

        const deleteButtonCell = document.createElement('td');
        const button = document.createElement('button');
        button.type = 'button';
        button.classList.add('btn', 'btn-sm', 'btn-danger', 'd-inline-flex', 'align-items-center', 'gap-1');
        button.setAttribute('data-action', 'booking-references#confirmAndDelete');
        button.setAttribute('data-index', index);
        button.setAttribute('aria-label', `Delete Booking Reference with name ${ref.name} and number ${ref.number}`);

        const icon = document.createElement('i');
        icon.classList.add('bi', 'bi-trash');

        button.appendChild(icon);
        button.appendChild(document.createTextNode('Delete'));

        deleteButtonCell.appendChild(button);

        row.appendChild(nameCell);
        row.appendChild(numberCell);
        row.appendChild(deleteButtonCell);

        this.tbodyTarget.appendChild(row);
      });
    }
  }

  // Update the hidden input field with the current references to synchronise with the server
  updateField() {
    this.dataFieldTarget.value = JSON.stringify(this.references);
  }

  confirmAndDelete(event) {
    // eslint-disable-next-line no-restricted-globals, no-alert
    if (confirm('Are you sure you want to delete this booking reference?')) {
      this.deleteReference(event);
    }
  }

  // For the edit page, reload existing references from the hidden input field
  loadFromField() {
    try {
      const existing = this.dataFieldTarget.value;
      if (existing) this.references = JSON.parse(existing);
    } catch (e) {
      this.references = [];
    }
  }

  // Show a warning message, updating a text element beneath the input fields
  showWarning(message) {
    this.warningTarget.textContent = message;
  }
}
