/**
 * Removes all children from a given node
 * @param node {HTMLElement} the node from which to remove all child nodes
 */
export function removeAllChildren(node) {
  while (node.firstChild) {
    node.removeChild(node.lastChild);
  }
}

/**
 * Appends a list of children to a node
 * @param node {HTMLElement} the node to append children to
 * @param children {Element[]} an array of children to append to node
 */
export function appendChildren(node, children) {
  children.forEach((c) => {
    node.append(c);
  });
}

/**
 * Sets the children of a node to match a given array
 * @param node {HTMLElement} the node to set children of
 * @param children {HTMLElement[]} desired array of children of node
 */
export function setChildList(node, children) {
  removeAllChildren(node);
  appendChildren(node, children);
}

/**
 * Creates an element with attributes
 * @param tag {string} the element tag to create
 * @param attributes {Object} attributes to set
 *        (i.e. {id: "my-element", class: "my-class1 my-class2"}
 * @param childList {HTMLElement[]} optional list of child elements to add
 * @returns {HTMLElement} the created element
 */
export function createElement(tag, attributes, childList = []) {
  const element = document.createElement(tag);
  Object.entries(attributes).forEach(([k, v]) => {
    const value = v.toString();
    const attributeName = k === 'className' ? 'class' : k;

    element.setAttribute(attributeName, value);
  });

  setChildList(element, childList);

  return element;
}
