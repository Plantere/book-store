<script setup lang="ts">

import { onBeforeMount, ref } from 'vue';
import { loadStripe } from "@stripe/stripe-js";
import { StripeElements, StripeElement } from 'vue-stripe-js'

import { useUserStore } from '@/stores/user';
import { useCartStore } from '@/stores/cart';
import { useNotificationStore } from '@/stores/notification';

import { api_v1_orders_create_path } from '@/utils/routes';
import { makeRequest } from '@/utils/request';
import Icon from '../shares/Icon.vue';

interface Props {
  address?: number,
  carrier?: number,
}

const user = useUserStore()
const notifications = useNotificationStore()
const cart = useCartStore()

const emit = defineEmits(["success", "failed"])
const props = defineProps<Props>()

const elementOptions = ref({
  style: {
    base: {
      iconColor: '#000',
      color: '#000',
      fontWeight: '500',
      fontFamily: 'Roboto, Open Sans, Segoe UI, sans-serif',
      fontSize: '16px',
      fontSmoothing: 'antialiased',
      '::placeholder': {
        color: '#000',
      },
    }
  },
  hidePostalCode: true,
})

const StripeElementRef = ref()
const StripeElementsRef = ref()
const isSubmiting = ref(false)

const stripeLoaded = ref(false)

const stripeKey = ref(import.meta.env.VITE_PUBLIC_STRIPE_KEY)

const getClientSecret = async () => {
  const response = await makeRequest(api_v1_orders_create_path(), {
    method: "POST",
    data: {
      cart: cart.cartList,
      address: props.address,
      carrier: props.carrier,
    }
  })

  if(!response.ok){
    let responseError;

    if(response.status !== 500){
      responseError = (await response.json()).error
    }

    throw new Error(responseError ?? "Unable to establish a connection with the payment gateway");
  }

  return (await response.json()).client_secret
}

const successPayment = () => {
  notifications.createNotification("Payment successfully processed", "success")
  emit("success")
  return true
}

const failedPayment = (error?: string) => {
  notifications.createNotification(error ?? "Card Declined", "error")
  emit("failed")
  return
}

const submitPayment = async () => {
  try {
    if (isSubmiting.value) return;

    isSubmiting.value = true;

    const clientSecret = await getClientSecret();

    const stripe = StripeElementsRef.value.instance;
    const paymentMethod = {
      card: StripeElementRef.value.stripeElement,
      billing_details: {
        name: `${user.profile.first_name} ${user.profile.last_name}`,
        email: user.user.email,
      },
    };

    const response = await stripe.confirmCardPayment(clientSecret, {
      payment_method: paymentMethod,
    });

    if (response.error) {
      failedPayment(response.error.message);
    } else {
      successPayment();
    }
  } catch (error: any) {
    failedPayment(error);
  } finally {
    isSubmiting.value = false;
  }
};

onBeforeMount(() => {loadStripe(stripeKey.value).then(() => stripeLoaded.value = true)})

</script>

<template>
  <StripeElements
    v-if="stripeLoaded"
    v-slot="{ elements }"
    ref="StripeElementsRef"
    :stripe-key="stripeKey"
  >
    <StripeElement
      class="py-4 px-2 border rounded-md border-gray-300"
      ref="StripeElementRef"
      :elements="elements"
      :options="elementOptions"
    />
  </StripeElements>

  <div class="flex justify-center">
    
    <button @click="submitPayment" :disabled="isSubmiting" class="block max-w-[350px] mt-2 w-full bg-violet-600 p-2 text-white shadow-md rounded-md text-sm font-semibold leading-6 disabled:opacity-50">
      <Icon name="loading" v-if="isSubmiting" class="inline mr-2 w-4 h-4 text-gray-200 animate-spin"></Icon>
      Pay now
    </button>
  </div>
</template>